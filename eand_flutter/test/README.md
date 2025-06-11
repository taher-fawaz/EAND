# Testing Guide

## Overview

This document provides instructions for running tests and generating code coverage reports for the project.

## Test Structure

The tests are organized following the same structure as the source code:

```
test/
  features/
    github_repos/
      data/
        datasources/
          github_local_datasource_test.dart
          github_remote_datasource_test.dart
        repositories/
          github_repository_impl_test.dart
      domain/
        usecases/
          get_repositories_usecase_test.dart
          get_commits_usecase_test.dart
      presentation/
        bloc/
          github_repo_bloc_test.dart
  src/
    app_test.dart
  fixtures/
    fixture_reader.dart
    github_repos.json
    github_commits.json
  widget_test.dart
```

## Running Tests

### Running All Tests

To run all tests without coverage:

```bash
flutter test
```

### Running Tests with Coverage

To run tests with coverage and generate a coverage report:

```bash
./run_tests_with_coverage.bat
```

This will:
1. Run all tests with coverage enabled
2. Generate an LCOV report
3. Generate an HTML report (if lcov is installed)
4. Open the HTML report in your default browser (Windows only)

## Writing Tests

### Mocking Dependencies

We use the `mockito` package for mocking dependencies in tests. To generate mock classes:

1. Add the `@GenerateMocks([])` annotation to your test file with the classes you want to mock
2. Run the build_runner command to generate the mock classes:

```bash
flutter pub run build_runner build
```

### Test Fixtures

Test fixtures (sample JSON data) are stored in the `test/fixtures/` directory. Use the `fixture_reader.dart` utility to load these fixtures in your tests.

### Best Practices

1. **Arrange-Act-Assert**: Structure your tests with clear sections for setup, execution, and verification
2. **Test Independence**: Each test should be independent and not rely on the state from other tests
3. **Descriptive Names**: Use descriptive test names that explain what is being tested
4. **Mock External Dependencies**: Always mock external dependencies like API calls and database access
5. **Test Edge Cases**: Include tests for error conditions and edge cases

## Code Coverage

The project aims for high code coverage. The coverage report will show which parts of the code are covered by tests and which are not.

To view the coverage report after running tests with coverage:

1. Open the HTML report at `coverage/html/index.html`
2. Look for areas with low coverage and add tests to improve coverage

## Continuous Integration

Tests are automatically run in the CI pipeline. Make sure all tests pass before submitting a pull request.