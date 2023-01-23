import numpy as np
import matplotlib.pyplot as plt

# Définir les valeurs de fréquence pour lesquelles la fonction de transfert est évaluée
f = np.linspace(-1000,1000,2001)

# Définir la fonction de transfert uniquement pour les fréquences dans l'intervalle [-500, 500]
H = np.where((f >= -500) & (f <= 500), 1, 0)

# Tracer la fonction de transfert
plt.plot(f, H)

# Ajouter des étiquettes aux axes
plt.xlabel('Fréquence (Hz)')
plt.ylabel('H(f)')

# Afficher le graphique
plt.show()


#------------------------------------------------------------------ 
#------------------------------------------------------------------ 

# Définir l'ordre du filtre
N = 500

# Définir la fonction de fenêtrage de Hamming
w = 0.54 - 0.46 * np.cos(2 * np.pi * np.arange(N) / (N - 1))

# Définir la réponse impulsionnelle du filtre en utilisant l'inverse de la transformée de Fourier
h = np.fft.ifft(w)

# Définir les valeurs de fréquence pour lesquelles la fonction de transfert est évaluée
f = np.linspace(-0.5, 0.5, N)

# Définir la fonction de transfert en utilisant la transformée de Fourier
H = np.fft.fft(h)

# Tracer la réponse impulsionnelle
plt.figure(1)
plt.stem(h)
plt.xlabel('n')
plt.ylabel('h(n)')

# Tracer la fonction de transfert
plt.figure(2)
plt.plot(f, np.abs(H))
plt.xlabel('Fréquence (Hz)')
plt.ylabel('H\'(f)')

# Afficher les graphiques
plt.show()
