
echo off

SET nom_Projet_Git=gcp-java-k8s
SET URL_Projet_Git=https://github.com/maddoudou22/gcp-java-k8s.git
SET Repertoire_Local_Projet=C:\awsLambda\java\gcp-java-k8s

cd %Repertoire_Local_Projet%

echo "Git Add ..."
git add -A

echo "Git Commit ..."
git commit -m "latest push from windows"

echo "Git Push ..."
git push %URL_Projet_Git%

