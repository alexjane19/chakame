#!/bin/bash

# Comprehensive fix for Riverpod compilation errors

files=(
    "lib/screens/favorites_screen.dart"
    "lib/screens/settings_screen.dart"
    "lib/screens/poem_detail_screen.dart"
    "lib/screens/desktop_main_screen.dart"
    "lib/widgets/random_poem_button.dart"
    "lib/widgets/poem_card.dart"
    "lib/widgets/poet_card.dart"
    "lib/widgets/favorite_button.dart"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "Fixing $file..."
        
        # Fix createState return types
        sed -i 's/State<.*> createState()/ConsumerState createState()/g' "$file"
        
        # Fix provider variable name conflicts
        sed -i 's/final poemProvider = ref.read(poemProvider.notifier);/final poemNotifier = ref.read(poemProvider.notifier);/g' "$file"
        sed -i 's/final favoritesProvider = ref.read(favoritesProvider.notifier);/final favoritesNotifier = ref.read(favoritesProvider.notifier);/g' "$file"
        sed -i 's/final settingsProvider = ref.watch(settingsProvider);/final settingsState = ref.watch(settingsProvider);/g' "$file"
        
        # Fix method calls on renamed variables
        sed -i 's/poemProvider\.loadRandomPoem/poemNotifier.loadRandomPoem/g' "$file"
        sed -i 's/poemProvider\.loadRandomPoemFromPoet/poemNotifier.loadRandomPoemFromPoet/g' "$file"
        sed -i 's/poemProvider\.loadPoets/poemNotifier.loadPoets/g' "$file"
        sed -i 's/favoritesProvider\.clearSearch/favoritesNotifier.clearSearch/g' "$file"
        sed -i 's/favoritesProvider\.searchFavorites/favoritesNotifier.searchFavorites/g' "$file"
        sed -i 's/favoritesProvider\.clearAllFavorites/favoritesNotifier.clearAllFavorites/g' "$file"
        sed -i 's/favoritesProvider\.exportFavorites/favoritesNotifier.exportFavorites/g' "$file"
        sed -i 's/favoritesProvider\.removeFromFavorites/favoritesNotifier.removeFromFavorites/g' "$file"
        sed -i 's/favoritesProvider\.addToFavorites/favoritesNotifier.addToFavorites/g' "$file"
        sed -i 's/favoritesProvider\.clearPoetFilter/favoritesNotifier.clearPoetFilter/g' "$file"
        sed -i 's/favoritesProvider\.filterByPoet/favoritesNotifier.filterByPoet/g' "$file"
        sed -i 's/favoritesProvider\.setSortType/favoritesNotifier.setSortType/g' "$file"
        
        # Fix function parameter types
        sed -i 's/PoemProvider poemProvider/PoemState poemState/g' "$file"
        sed -i 's/FavoritesProvider favoritesProvider/FavoritesState favoritesState/g' "$file"
        
        # Fix property access for state objects
        sed -i 's/settingsProvider\.darkMode/settingsState.darkMode/g' "$file"
        sed -i 's/settingsProvider\.selectedFont/settingsState.selectedFont/g' "$file"
        
        echo "Fixed $file"
    fi
done

echo "All files have been processed."