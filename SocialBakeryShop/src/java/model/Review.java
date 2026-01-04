package model;

import java.sql.Timestamp;
import java.util.Date;

/**
 * Review model class representing the review table in database
 */
public class Review {
    private int id;
    private int userId;
    private int productId;
    private int rating;
    private String komentar;
    private Timestamp tanggalReview;
    
    // Default constructor
    public Review() {
        this.tanggalReview = new Timestamp(System.currentTimeMillis());
    }
    
    // Constructor with all fields except id (for new reviews)
    public Review(int userId, int productId, int rating, String komentar) {
        this.userId = userId;
        this.productId = productId;
        this.rating = rating;
        this.komentar = komentar;
        this.tanggalReview = new Timestamp(System.currentTimeMillis());
    }
    
    // Constructor with all fields (for existing reviews)
    public Review(int id, int userId, int productId, int rating, String komentar, Timestamp tanggalReview) {
        this.id = id;
        this.userId = userId;
        this.productId = productId;
        this.rating = rating;
        this.komentar = komentar;
        this.tanggalReview = tanggalReview;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public int getProductId() {
        return productId;
    }
    
    public void setProductId(int productId) {
        this.productId = productId;
    }
    
    public int getRating() {
        return rating;
    }
    
    public void setRating(int rating) {
        if (rating >= 1 && rating <= 5) {
            this.rating = rating;
        } else {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }
    }
    
    public String getKomentar() {
        return komentar;
    }
    
    public void setKomentar(String komentar) {
        this.komentar = komentar;
    }
    
    public Timestamp getTanggalReview() {
        return tanggalReview;
    }
    
    public Date getTanggalReviewAsDate() {
        return tanggalReview != null ? new Date(tanggalReview.getTime()) : null;
    }
    
    public void setTanggalReview(Timestamp tanggalReview) {
        this.tanggalReview = tanggalReview;
    }
    
    // Utility methods
    public boolean isValidRating() {
        return rating >= 1 && rating <= 5;
    }
    
    public String getRatingStars() {
        StringBuilder stars = new StringBuilder();
        for (int i = 1; i <= 5; i++) {
            if (i <= rating) {
                stars.append("★");
            } else {
                stars.append("☆");
            }
        }
        return stars.toString();
    }
    
    public String getShortComment() {
        if (komentar == null) return "";
        return komentar.length() > 100 ? komentar.substring(0, 100) + "..." : komentar;
    }
    
    @Override
    public String toString() {
        return "Review{" +
                "id=" + id +
                ", userId=" + userId +
                ", productId=" + productId +
                ", rating=" + rating +
                ", komentar='" + komentar + '\'' +
                ", tanggalReview=" + tanggalReview +
                '}';
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        
        Review review = (Review) obj;
        return id == review.id;
    }
    
    @Override
    public int hashCode() {
        return Integer.hashCode(id);
    }
}