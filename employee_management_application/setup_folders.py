import os

folders = [
    "lib/core/error",
    "lib/core/network",
    "lib/core/theme",
    "lib/core/utils",
    "lib/features/auth/domain/entities",
    "lib/features/auth/domain/repositories",
    "lib/features/auth/domain/usecases",
    "lib/features/auth/data/models",
    "lib/features/auth/data/repositories",
    "lib/features/auth/data/datasources",
    "lib/features/auth/presentation/pages",
    "lib/features/auth/presentation/widgets",
    "lib/features/auth/presentation/providers",
    "lib/features/employee/domain/entities",
    "lib/features/employee/domain/repositories",
    "lib/features/employee/domain/usecases",
    "lib/features/employee/data/models",
    "lib/features/employee/data/repositories",
    "lib/features/employee/data/datasources",
    "lib/features/employee/presentation/pages",
    "lib/features/employee/presentation/widgets",
    "lib/features/employee/presentation/providers"
]

for folder in folders:
    os.makedirs(folder, exist_ok=True)

print("Folders created successfully.")
