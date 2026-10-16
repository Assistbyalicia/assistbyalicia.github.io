#!/bin/bash
# Double-cliquer sur ce fichier dans le Finder pour prévisualiser un article draft
# Il s'ouvre dans Terminal et lance le site en local sur localhost:8080

cd "$(dirname "$0")"

echo ""
echo "===  Prévisualisation d'article — Assist by Alicia  ==="
echo ""

# Récupérer les dernières branches distantes
echo "Récupération des branches GitHub..."
git fetch --quiet

# Lister les branches draft/article-* disponibles
BRANCHES=$(git branch -a | grep "draft/article-" | sed 's|.*draft/article-||' | sort -u)

if [ -z "$BRANCHES" ]; then
  echo ""
  echo "Aucun article draft trouvé. Peut-être que la routine du lundi n'a pas encore tourné ?"
  echo ""
  read -p "Appuie sur Entrée pour fermer..."
  exit 0
fi

echo "Articles disponibles à prévisualiser :"
echo ""
i=1
declare -a SLUGS
while IFS= read -r slug; do
  echo "  [$i] $slug"
  SLUGS[$i]="$slug"
  ((i++))
done <<< "$BRANCHES"

echo ""
read -p "Lequel veux-tu prévisualiser ? (numéro) : " choice

SLUG="${SLUGS[$choice]}"
if [ -z "$SLUG" ]; then
  echo "Choix invalide."
  read -p "Appuie sur Entrée pour fermer..."
  exit 1
fi

echo ""
echo "Chargement de l'article : $SLUG..."
git checkout "draft/article-$SLUG" --quiet 2>/dev/null || git checkout "remotes/origin/draft/article-$SLUG" --quiet

echo ""
echo "Lancement du site en local..."
echo "Ouvre ton navigateur sur : http://localhost:8080/$SLUG.html"
echo "(Ctrl+C pour arrêter)"
echo ""

npm start
