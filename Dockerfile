# Dockerfile untuk aplikasi Node.js

# Menggunakan Node.js LTS (Long-Term Support) sebagai base image
FROM node:lts

# Menetapkan direktori kerja di dalam kontainer Docker
WORKDIR /app

# Menyalin file package.json dan package-lock.json (jika ada) ke dalam direktori kerja (/app)
COPY package*.json ./

# Menginstal dependencies yang diperlukan
RUN npm install

# Menyalin semua file dari direktori saat ini ke dalam direktori kerja (/app) di dalam image Docker
COPY . .

# Menetapkan perintah default yang akan dijalankan ketika kontainer berdasarkan image ini dimulai
CMD ["node", "app.js"]
