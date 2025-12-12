# Running Tests

## Prerequisites

Make sure you have all dependencies installed:

```bash
pip install -r requirements.txt
```

## Running the Tests

### Run all tests:
```bash
pytest tests/ -v
```

### Run only auth tests:
```bash
pytest tests/test_auth.py -v
```

### Run with more detailed output:
```bash
pytest tests/test_auth.py -v -s
```

### Run a specific test class:
```bash
pytest tests/test_auth.py::TestSignup -v
pytest tests/test_auth.py::TestLogin -v
pytest tests/test_auth.py::TestMe -v
```

### Run a specific test:
```bash
pytest tests/test_auth.py::TestSignup::test_signup_success -v
```

### Run with coverage (if pytest-cov is installed):
```bash
pytest tests/ --cov=app --cov-report=html
```

## Expected Output

When tests pass, you should see output like:
```
tests/test_auth.py::TestSignup::test_signup_success PASSED
tests/test_auth.py::TestSignup::test_signup_duplicate_email PASSED
...
```

All tests should pass if everything is working correctly.

