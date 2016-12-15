require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'forum visit', feature: true, js: true do
  it 'visit forum open' do
    visit forum_subject_path(forum_subjects(:one))

    country = countries(:france)

    visit forum_families_path(country_id: country.id)
    has_css?('.forum_family-panel')

    category = country.forum_categories.first
    within('li.forum_category-panel') do
      click_on(category.name)
    end

    subject = category.forum_subjects.first

    ## IMPORTANT WAIT TO HAVE THE PAGE LOADED
    expect(page).to have_content(subject.name)
    within('main.container') do
      # expect(page).to have_content(I18n.translate('activerecord.models.forum_category', count:2).capitalize)
    end
  end
end

RSpec.feature 'Forum answer management', type: :feature, js: true do
  scenario 'visit forum', js: true do
    country = countries(:france)
    visit forum_families_path(country_id: country.id)
    has_css?('.forum_family-panel')

    forum_category = country.forum_categories.first
    within('li.forum_category-panel') do
      click_on(forum_category.name)
    end

    expect(find('h1')).to have_content(forum_category.name)

    forum_subject = forum_category.forum_subjects.first
    # within("#forum_subject_#{forum_category.id}") do
    click_on(forum_subject.name)
    # end
    expect(find('h1')).to have_content(forum_subject.name)
  end

  scenario 'update forum subject text', js: true do
    # Log In
    customer = customers(:one)
    login_as customer, scope: :customer
    visit '/'

    # visit forum subject
    forum_subject = forum_subjects(:one)
    expect(forum_subject.customer.id).to eq(customer.id)

    visit forum_subject_path(forum_subject)

    # edit a subject
    within("li.forum_subject_#{forum_subject.id}") do
      action = I18n.translate('helpers.action.edit')
      find("a[alt=#{action}]").click
    end

    # update the text
    # check if the form is ready
    expect(page).to have_css("#edit_forum_subject_#{forum_subject.id}")

    text = 'This is the new text'
    within("#edit_forum_subject_#{forum_subject.id}") do
      # this is a client side action
      # we use jquery to change the value
      page.execute_script("$('textarea#forum_subject_text').text('#{text}')")
      sleep(1)
      find('input[name="commit"]').click
    end

    # check if the page is ready
    expect(page).to have_no_xpath('//input')
    expect(page).to have_content(text)
    # retreive from DB
    forum_subject = ForumSubject.find(forum_subject.id)
    expect(forum_subject.text).to eq(text)
  end

  scenario 'add answer to subject', js: true do
    # Log In
    customer = customers(:one)
    login_as customer, scope: :customer

    # visit forum subject
    forum_subject = forum_subjects(:one)
    expect(forum_subject.customer.id).to eq(customer.id)
    visit forum_subject_path(forum_subject)

    # add an answer
    within("li.forum_subject_#{forum_subject.id}") do
      action = I18n.translate('helpers.action.forum_answer.create')
      find("a[alt='#{action}']").click
    end

    # check if the form is ready
    expect(page).to have_css('#new_forum_answer')

    text = 'This is the new answer text'
    within('#new_forum_answer') do
      # this is a client side action
      # we use jquery to change the value
      expect(page).to have_xpath('//input')
      page.execute_script("$('textarea#forum_answer_text').text('#{text}')")
      sleep(1)
      find('input[name="commit"]').click
    end

    # wait for end of process to create

    expect(page).to have_no_xpath('//input')
    expect(page).to have_text(text)

    # retreive from DB
    # let some time to the DB
    forum_subject = ForumSubject.find(forum_subject.id)

    # check update in DB
    forum_answer = forum_subject.forum_answers.first
    expect(forum_answer.text).to eq(text)

    # check result on the page
    expect(page).to have_css("li.forum_answer_#{forum_answer.id}")
    expect(page).to have_content(text)

    # check if the page is ready
  end

  scenario 'add comment to answer', js: true do
    # Log In
    customer = customers(:one)
    login_as customer, scope: :customer

    # visit forum subject
    forum_subject = forum_subjects(:one)
    expect(forum_subject.customer.id).to eq(customer.id)
    visit forum_subject_path(forum_subject)

    forum_answer = forum_subject.forum_answers.first

    # add an comment to answer
    within("li.forum_answer_#{forum_answer.id}") do
      action = I18n.translate('helpers.action.comment.create')
      find("a[alt='#{action}']").click
    end

    # check if the form is ready
    expect(page).to have_css('#new_comment')

    text = 'This is the new comment text for answer'
    within('#new_comment') do
      # this is a client side action
      # we use jquery to change the value
      expect(page).to have_xpath('//input')
      page.execute_script("$('textarea#comment_text').text('#{text}')")
      sleep(1)
      find('input[name="commit"]').click
    end

    expect(page).to have_no_xpath('//input')
    expect(page).to have_text(text)

    # retreive from DB
    # let some time to the DB
    forum_answer = ForumAnswer.find(forum_answer.id)

    # check update in DB
    comment = forum_answer.comments.last
    expect(comment.text).to eq(text)

    # check result on the page
    expect(page).to have_css("li.comment_#{comment.id}")
    expect(page).to have_content(text)

    # @TODO look for the number of comments displayed on page

    # check if the page is ready
  end
end
