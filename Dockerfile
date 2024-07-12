# Dockerfile untuk aplikasi Nginx

# Menggunakan Nginx sebagai base image
FROM nginx

# Menyalin konfigurasi Nginx dan file static ke dalam image
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80 untuk mengakses Nginx
EXPOSE 80

# Perintah default yang akan dijalankan ketika kontainer berdasarkan image ini dimulai
CMD ["nginx", "-g", "daemon off;"]
