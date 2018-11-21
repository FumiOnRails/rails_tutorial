require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params:{user:{name:'',email:"invalid@mail",password:"foo",password_confirmation:"bar"}}
    assert_template 'users/edit'
    assert_select 'div.alert',"The form contains 4 errors."
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user),params:{user:{name:name,email:email,password:"",password_confirmation:""}}
    assert_not flash.empty?
    @user.reload
    assert_equal name,@user.name
    assert_equal email,@user.email
  end

  test "successful edit with friendly fowarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user),params:{user:{name:name,email:email,password:"",password_confirmation:""}}
    assert_not flash.empty?
    @user.reload
    assert_equal name,@user.name
    assert_equal email,@user.email
    delete logout_path(@user)
    assert_redirected_to root_path
    get login_path
    post login_path, params: {session:{email:@user.email,password: "password"}}
    assert_redirected_to @user
  end

end
