============================= auth test =============================
Below is the report of the auth test cases.

tests/test_auth.py::TestSignup::test_signup_success PASSED               
tests/test_auth.py::TestSignup::test_signup_duplicate_email PASSED       
tests/test_auth.py::TestSignup::test_signup_invalid_email PASSED         
tests/test_auth.py::TestSignup::test_signup_missing_fields PASSED        
tests/test_auth.py::TestLogin::test_login_success PASSED                 
tests/test_auth.py::TestLogin::test_login_wrong_password PASSED          
tests/test_auth.py::TestLogin::test_login_wrong_email PASSED             
tests/test_auth.py::TestLogin::test_login_invalid_email_format PASSED    
tests/test_auth.py::TestLogin::test_login_missing_fields PASSED          
tests/test_auth.py::TestMe::test_me_success PASSED                       
tests/test_auth.py::TestMe::test_me_no_token PASSED                      
tests/test_auth.py::TestMe::test_me_invalid_token PASSED                 
tests/test_auth.py::TestMe::test_me_expired_token PASSED                 


Summary: All 13 auth tests pass