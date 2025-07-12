#!/bin/bash

# Script to fix all provider imports to use Riverpod

# List of files to fix
files=(
    "lib/screens/desktop_main_screen.dart"
    "lib/screens/favorites_screen.dart"
    "lib/screens/settings_screen.dart"
    "lib/screens/poem_detail_screen.dart"
    "lib/widgets/random_poem_button.dart"
    "lib/widgets/poem_card.dart"
    "lib/widgets/poet_card.dart"
    "lib/widgets/favorite_button.dart"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "Fixing $file..."
        
        # Replace imports
        sed -i 's/import '\''package:provider\/provider.dart'\'';/import '\''package:flutter_riverpod\/flutter_riverpod.dart'\'';/g' "$file"
        
        # Replace StatefulWidget with ConsumerStatefulWidget
        sed -i 's/extends StatefulWidget/extends ConsumerStatefulWidget/g' "$file"
        
        # Replace State with ConsumerState
        sed -i 's/extends State</extends ConsumerState</g' "$file"
        
        # Replace StatelessWidget with ConsumerWidget
        sed -i 's/extends StatelessWidget/extends ConsumerWidget/g' "$file"
        
        # Replace Widget build(BuildContext context) with Widget build(BuildContext context, WidgetRef ref)
        sed -i 's/Widget build(BuildContext context)/Widget build(BuildContext context, WidgetRef ref)/g' "$file"
        
        # Replace Provider.of patterns
        sed -i 's/Provider\.of<PoemProvider>(context, listen: false)/ref.read(poemProvider.notifier)/g' "$file"
        sed -i 's/Provider\.of<PoemProvider>(context)/ref.watch(poemProvider)/g' "$file"
        sed -i 's/Provider\.of<FavoritesProvider>(context, listen: false)/ref.read(favoritesProvider.notifier)/g' "$file"
        sed -i 's/Provider\.of<FavoritesProvider>(context)/ref.watch(favoritesProvider)/g' "$file"
        sed -i 's/Provider\.of<SettingsProvider>(context, listen: false)/ref.read(settingsProvider.notifier)/g' "$file"
        sed -i 's/Provider\.of<SettingsProvider>(context)/ref.watch(settingsProvider)/g' "$file"
        
        # Replace Consumer patterns
        sed -i 's/Consumer<PoemProvider>/Consumer/g' "$file"
        sed -i 's/Consumer<FavoritesProvider>/Consumer/g' "$file"
        sed -i 's/Consumer<SettingsProvider>/Consumer/g' "$file"
        
        echo "Fixed $file"
    else
        echo "File $file not found"
    fi
done

echo "All files have been processed."