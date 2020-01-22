import numpy as np
import matplotlib.pyplot as plt

# Fixing random state for reproducibility
np.random.seed(19680801)


N = 50
x = range(50)
y = np.zeros(50)
x2 = np.random.rand(N)
y2 = np.random.rand(N)
colors = np.random.rand(N)
area = (30 * np.random.rand(N))**2  # 0 to 15 point radii

plt.scatter(x, y)
plt.scatter(x2, y2)
plt.show()