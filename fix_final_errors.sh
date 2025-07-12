#!/bin/bash

echo "Fixing final compilation errors..."

# Fix Consumer builder patterns
files=(
    "lib/screens/favorites_screen.dart"
    "lib/screens/poem_detail_screen.dart"
    "lib/widgets/random_poem_button.dart"
    "lib/widgets/poem_card.dart"
    "lib/widgets/favorite_button.dart"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "Fixing Consumer patterns in $file..."
        
        # Fix Consumer builder patterns that still have old parameter names
        sed -i 's/builder: (context, favoritesProvider, child)/builder: (context, ref, child)/g' "$file"
        sed -i 's/builder: (context, poemProvider, child)/builder: (context, ref, child)/g' "$file"
        
        # Fix widget build method signatures
        sed -i 's/Widget build(BuildContext context, WidgetRef ref)/Widget build(BuildContext context)/g' "$file"
        
        echo "Fixed Consumer patterns in $file"
    fi
done

# Fix specific method calls that still reference old provider variables
echo "Fixing method calls..."

# In random_poem_button.dart
sed -i 's/poemProvider\.isLoading/poemState.isLoading/g' "lib/widgets/random_poem_button.dart"
sed -i 's/poemProvider\.currentPoem/poemState.currentPoem/g' "lib/widgets/random_poem_button.dart"

# In poem_card.dart  
sed -i 's/favoritesProvider\.isFavorite/ref.read(favoritesProvider.notifier).isFavorite/g' "lib/widgets/poem_card.dart"
sed -i 's/favoritesProvider\.toggleFavorite/ref.read(favoritesProvider.notifier).toggleFavorite/g' "lib/widgets/poem_card.dart"

# In favorite_button.dart
sed -i 's/favoritesProvider\.isFavorite/ref.read(favoritesProvider.notifier).isFavorite/g' "lib/widgets/favorite_button.dart"
sed -i 's/favoritesProvider\.toggleFavorite/ref.read(favoritesProvider.notifier).toggleFavorite/g' "lib/widgets/favorite_button.dart"

# In poem_detail_screen.dart
sed -i 's/favoritesProvider\.isFavorite/ref.read(favoritesProvider.notifier).isFavorite/g' "lib/screens/poem_detail_screen.dart"
sed -i 's/favoritesProvider\.toggleFavorite/ref.read(favoritesProvider.notifier).toggleFavorite/g' "lib/screens/poem_detail_screen.dart"

# In favorites_screen.dart
sed -i 's/favoritesProvider\.getUniquePoetNames/ref.read(favoritesProvider.notifier).getUniquePoetNames/g' "lib/screens/favorites_screen.dart"
sed -i 's/favoritesProvider\.isLoading/favoritesState.isLoading/g' "lib/screens/favorites_screen.dart"
sed -i 's/favoritesProvider\.isEmpty/favoritesState.isEmpty/g' "lib/screens/favorites_screen.dart"
sed -i 's/favoritesProvider\.isSearchEmpty/favoritesState.isSearchEmpty/g' "lib/screens/favorites_screen.dart"
sed -i 's/favoritesProvider\.favorites/favoritesState.filteredFavorites/g' "lib/screens/favorites_screen.dart"
sed -i 's/favoritesProvider\.sortType/favoritesState.sortType/g' "lib/screens/favorites_screen.dart"
sed -i 's/favoritesProvider\.favoritesCount/favoritesState.favoritesCount/g' "lib/screens/favorites_screen.dart"

# Fix variable declarations that still refer to old provider names
sed -i 's/final favoritesNotifier = ref.read(favoritesProvider.notifier);/final favoritesNotifier = ref.read(favoritesProvider.notifier);/g' "lib/screens/poem_detail_screen.dart"

echo "All fixes applied!"