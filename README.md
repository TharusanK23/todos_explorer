# Todos Explorer

A Flutter application that loads todos from the [JSONPlaceholder API](https://jsonplaceholder.typicode.com/todos/), displays them in a card-based layout, and supports filtering, sorting, searching, and paginated loading.

---

## State Management

This project uses a **hybrid architecture** combining two complementary patterns:

| Layer | Approach |
|-------|----------|
| Business Logic | **BLoC** (`flutter_bloc`) — handles data fetching events and state transitions |
| Presentation | **Stacked MVVM** (`stacked`) — holds UI-reactive state (filters, sort, search, pagination) |
| Dependency Injection | **GetIt** — service locator for wiring layers together |

**Why hybrid?** BLoC manages the async network lifecycle cleanly (loading / loaded / error), while the Stacked ViewModel owns the derived UI state (visible todos after filter/sort/search) without polluting the BLoC with presentation concerns.

---

## Architecture

The project follows **Clean Architecture** with a feature-based folder structure:

```
lib/
├── main.dart                        # Entry point
├── router.dart                      # GoRouter navigation
├── injection_container.dart         # GetIt DI setup
├── export/exports.dart              # Barrel exports
├── core/
│   ├── constants/app_constants.dart # App name, base URL (from .env)
│   ├── theme/app_colors.dart        # Color palette
│   ├── error/                       # Exceptions & Failures
│   └── usecases/usecase.dart        # Abstract UseCase base class
├── features/
│   └── todos/
│       ├── data/
│       │   ├── datasourse/          # Remote data source (HTTP)
│       │   ├── model/               # TodoModel (fromJson)
│       │   └── repository/          # Repository implementation
│       ├── domain/
│       │   ├── entity/              # TodoEntity (pure business object)
│       │   ├── repository/          # Repository interface
│       │   └── usecase/             # GetTodosUseCase
│       └── presentation/
│           ├── bloc/                # TodoBloc, TodoEvent, TodoState
│           ├── model/               # TodoViewModel (Stacked)
│           ├── view/                # TodoListView (main screen)
│           └── widgets/             # TodoCard, TodoList
└── utils/enums.dart                 # FilterType, SortType enums
```

### Data Flow

```
UI (TodoListView + TodoViewModel)
        │
        ▼
TodoBloc ← GetAllTodoEvent
        │
        ▼
GetTodosUseCase
        │
        ▼
TodoRepositoryImpl
        │
        ▼
TodoRemoteDataSource  →  GET /todos/  →  List<TodoModel>
        │
        ▼
Either<Failure, List<TodoEntity>>
        │
        ▼
BLoC emits TodoLoaded / TodoError
        │
        ▼
ViewModel applies filter → sort → search → pagination
        │
        ▼
UI rebuilds with visibleTodos
```

---

## Features

- **Load todos** from `https://jsonplaceholder.typicode.com/todos/`
- **Filter** by status: All / Completed / Pending
- **Sort** by title: A→Z / Z→A
- **Pull Refresh** for reload list
- **Search** with real-time highlighting — matching cards turn light yellow (`0xFFFFF9C4`)
- **Pagination** — loads 10 items at a time with a "Load More" button
- **Footer** — persistent "Showing X of Y todos" count
- **Responsive layout** — single-column on phones, graceful on wider screens
- **Error handling** — custom exceptions and failures surfaced in the UI

---

## Tech Stack

| Package | Purpose |
|---------|---------|
| `flutter_bloc` | BLoC state management |
| `bloc` | Core BLoC library |
| `equatable` | Value equality for events/states |
| `stacked` | MVVM ViewModel pattern |
| `get_it` | Service locator / DI |
| `go_router` | Declarative navigation |
| `http` | REST API calls |
| `dartz` | Functional `Either` result type |
| `flutter_dotenv` | `.env` config for base URL |

---

## Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- An emulator or physical device

### Setup

```bash
# 1. Clone the repo
git clone <repo-url>
cd todos_explorer

# 2. Install dependencies
flutter pub get

# 3. Create the environment file
echo "BASE_URL=https://jsonplaceholder.typicode.com" > .env

# 4. Run the app
flutter run
```

### Build

```bash
# Debug
flutter run

# Release APK
flutter build apk --release

# Release iOS
flutter build ios --release
```

---

## Project Structure Details

### `TodoEntity` (domain layer)
Pure business object with no framework dependencies:

```dart
class TodoEntity {
  final int userId;
  final int id;
  final String title;
  final bool completed;
}
```

### `TodoModel` (data layer)
Extends `TodoEntity`, adds JSON deserialization:

```dart
factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
  userId: json['userId'],
  id: json['id'],
  title: json['title'],
  completed: json['completed'],
);
```

### `TodoBloc` states

| State | Meaning |
|-------|---------|
| `TodoInitial` | Not yet fetched |
| `TodoLoading` | Fetch in progress |
| `TodoLoaded(todos)` | Data ready |
| `TodoError` | Fetch failed |

### `TodoViewModel` (Stacked)
Owns all UI-derived state:
- `changeFilter(FilterType)` — All / Completed / Pending
- `changeSort(SortType)` — Ascending / Descending
- `onSearch(String)` — Filters list and drives highlight flag
- `loadMore()` — Appends next 10 items to `visibleTodos`

---

## UI Layout

```
Scaffold
├── AppBar(title: 'Todos Explorer', actions: [SortPopupMenu])
└── body: Column(
    ├── Padding(SearchTextField)       ← "Search todos..."
    ├── Padding(FilterChipsRow)        ← All | Completed | Pending
    └── Expanded(ListView → TodoCard)
        )
└── bottomNavigationBar: BottomAppBar
    └── "Showing X of Y todos"
```

**TodoCard** highlights in `Color(0xFFFFF9C4)` when the title matches the search query:

```
ListTile
├── leading:  Icons.check_circle (green) or Icons.circle_outlined (grey)
├── title:    todo.title  (FontWeight.w600, ellipsis)
├── subtitle: "ID: {id} • User: {userId}"
└── trailing: "Completed" (green) or "Pending" (grey)
```

---

## Environment Variables

The app reads `BASE_URL` from a `.env` file at the project root:

```
BASE_URL=https://jsonplaceholder.typicode.com
```

Loaded via `flutter_dotenv` at startup and accessed through `AppConstants.baseUrl`.

---

## Error Handling

| Exception | Maps to | Trigger |
|-----------|---------|---------|
| `ServerException` | `ServerFailure` | Non-200 HTTP response |
| `CacheException` | `CacheFailure` | Local storage failure |
| `InvalidCredentialsException` | `InvalidCredentialsFailure` | Auth error |
| Generic error | `APIFailure` | Any other network error |

Failures are returned as `Left<Failure>` via `dartz`'s `Either` type, keeping error handling explicit and composable through each layer.

---

## Fonts

The app uses the **Poppins** font family, bundled in the `fonts/` directory.

#### - I did this README.md file using with AI