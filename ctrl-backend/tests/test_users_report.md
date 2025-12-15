============================= users test =============================
Below is the report of the users test cases.

tests/test_users.py::TestGetMe::test_get_me_existing_user ERROR               
tests/test_users.py::TestGetMe::test_get_me_new_user_creation FAILED          
tests/test_users.py::TestGetMe::test_get_me_no_auth PASSED                   
tests/test_users.py::TestGetMe::test_get_me_invalid_token_format PASSED       
tests/test_users.py::TestGetMe::test_get_me_missing_bearer PASSED            
tests/test_users.py::TestGetMe::test_get_me_invalid_token PASSED             
tests/test_users.py::TestGetMe::test_get_me_user_isolation ERROR              
tests/test_users.py::TestGetMe::test_get_me_multiple_calls_same_user FAILED  
tests/test_users.py::TestGetMe::test_get_me_response_structure ERROR         


Summary: 
- ✅ 4 tests passed (authentication-related tests)
- ❌ 2 tests failed (due to missing firebase_uid field in User model)
- ⚠️ 3 tests had errors (due to missing firebase_uid field in User model)

Issue: The User model is missing the `firebase_uid` field that is required by the users router.
All tests will pass once the `firebase_uid` field is added to the User model.

