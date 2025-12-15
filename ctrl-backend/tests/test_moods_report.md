============================= moods test =============================
Below is the report of the moods test cases.

tests/test_moods.py::TestCreateMood::test_create_mood_success ERROR               
tests/test_moods.py::TestCreateMood::test_create_mood_missing_fields ERROR        
tests/test_moods.py::TestCreateMood::test_create_mood_no_auth PASSED              
tests/test_moods.py::TestCreateMood::test_create_mood_user_not_found FAILED        
tests/test_moods.py::TestCreateMood::test_create_mood_multiple_entries ERROR       
tests/test_moods.py::TestListMoods::test_list_moods_success ERROR                 
tests/test_moods.py::TestListMoods::test_list_moods_empty ERROR                   
tests/test_moods.py::TestListMoods::test_list_moods_no_auth PASSED               
tests/test_moods.py::TestListMoods::test_list_moods_user_isolation ERROR          


Summary: 2 passed, 1 failed, 6 errors

Issues Found:
- User model missing 'firebase_uid' field (causes 6 errors)
- MoodEntry model field mismatch (mood_score/energy_level/stress_level vs mood/note)
- Duplicate route definition in moods.py

Note: Tests are properly structured but require model/database schema fixes to pass.
See TESTING_GUIDE.md for detailed solutions.

