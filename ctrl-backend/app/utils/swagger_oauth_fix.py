from fastapi.openapi.utils import get_openapi

def fix_swagger_login(app):
    openapi_schema = get_openapi(
        title=app.title,
        version="1.0.0",
        routes=app.routes,
    )

    # DO NOT double-prefix paths
    # Swagger sometimes incorrectly prepends routers – we normalize them here.
    corrected_paths = {}

    for path, methods in openapi_schema["paths"].items():
        # Replace accidental double prefix
        new_path = path.replace("/api/v1/api/v1", "/api/v1")

        corrected_paths[new_path] = methods

    openapi_schema["paths"] = corrected_paths
    return openapi_schema
