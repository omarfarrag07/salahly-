<?php

namespace App\Services;

/**
 * DistanceService - Handles geographic distance calculations and radius-based queries
 */
class DistanceService
{
    /**
     * Calculate distance between two geographic coordinates using Haversine formula
     * 
     * @param float $lat1 Latitude of first point
     * @param float $lng1 Longitude of first point
     * @param float $lat2 Latitude of second point
     * @param float $lng2 Longitude of second point
     * @return float Distance in kilometers
     */
    public function calculateDistance(float $lat1, float $lng1, float $lat2, float $lng2): float
    {
        $earthRadiusKm = 6371; // Earth's radius in kilometers

        $dLat = $this->degreesToRadians($lat2 - $lat1);
        $dLng = $this->degreesToRadians($lng2 - $lng1);

        $lat1Rad = $this->degreesToRadians($lat1);
        $lat2Rad = $this->degreesToRadians($lat2);

        $a = sin($dLat / 2) * sin($dLat / 2) +
             sin($dLng / 2) * sin($dLng / 2) * cos($lat1Rad) * cos($lat2Rad);

        $c = 2 * atan2(sqrt($a), sqrt(1 - $a));

        return $earthRadiusKm * $c;
    }

    /**
     * Get Haversine formula SQL for distance calculation
     * Used for ordering and filtering in database queries
     * 
     * @param float $lat Reference latitude
     * @param float $lng Reference longitude
     * @return array SQL calculation and parameters
     */
    public function getHaversineSQL(float $lat, float $lng): array
    {
        $sql = "6371 * acos(
            cos(radians(?)) * cos(radians(lat)) *
            cos(radians(lng) - radians(?)) +
            sin(radians(?)) * sin(radians(lat))
        )";

        $params = [$lat, $lng, $lat];

        return [$sql, $params];
    }

    /**
     * Convert degrees to radians
     * 
     * @param float $degrees
     * @return float
     */
    private function degreesToRadians(float $degrees): float
    {
        return $degrees * (M_PI / 180);
    }

    /**
     * Validate geographic coordinates
     * 
     * @param float $lat Latitude
     * @param float $lng Longitude
     * @return bool
     */
    public function isValidCoordinates(float $lat, float $lng): bool
    {
        return $lat >= -90 && $lat <= 90 && $lng >= -180 && $lng <= 180;
    }
}
