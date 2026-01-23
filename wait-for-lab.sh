#!/bin/bash

# Script pour démarrer le lab Ansible et attendre qu'il soit prêt
# Usage: ./wait-for-lab.sh

set -e

echo "🚀 Démarrage du lab Ansible Docker..."
echo ""

# Démarrer les containers
docker-compose -f docker-compose-lab.yml up -d

echo "✅ 10 containers lancés"
echo ""
echo "⏳ Attente que tous les containers soient prêts..."
echo "   📝 Cela peut prendre 5-10 minutes selon votre connexion internet"
echo "   💡 Les containers installent SSH, Python3 et sudo au premier démarrage"
echo ""

SECONDS=0
LAST_CHECK=0

# Attendre que tous les containers répondent au ping Ansible
while true; do
  # Test Ansible toutes les 30 secondes
  if ansible -i inventory-lab.yml all -m ping > /dev/null 2>&1; then
    break
  fi
  
  ELAPSED=$((SECONDS))
  MINUTES=$((ELAPSED / 60))
  SECS=$((ELAPSED % 60))
  
  # Afficher un message toutes les 30 secondes
  if [ $((ELAPSED - LAST_CHECK)) -ge 30 ]; then
    echo "   ⏱️  ${MINUTES}m ${SECS}s - Installation en cours..."
    LAST_CHECK=$ELAPSED
  fi
  
  sleep 5
done

TOTAL_MINUTES=$((SECONDS / 60))
TOTAL_SECS=$((SECONDS % 60))

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Tous les containers sont prêts !"
echo "⏱️  Temps total: ${TOTAL_MINUTES}m ${TOTAL_SECS}s"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🎉 Vous pouvez maintenant commencer les exercices !"
echo ""
echo "📋 Commandes utiles:"
echo "   ansible -i inventory-lab.yml all -m ping        # Tester la connexion"
echo "   docker ps                                        # Voir les containers"
echo "   docker logs ansible-lab-web01                    # Voir les logs"
echo ""
