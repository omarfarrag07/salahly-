<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('service_requests', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('service_id')->constrained()->onDelete('cascade'); // Add this if not present
            $table->string('title_en')->nullable(); // Optional, if you want to keep it
            $table->string('title_ar')->nullable(); // Optional, if you want to keep it
            $table->text('description_en');
            $table->text('description_ar')->nullable();
            $table->string('location');
            $table->decimal('price', 10, 2)->nullable(); // <-- Add this line
            $table->timestamp('scheduled_at')->nullable();
            $table->string('status')->default('pending');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('service_requests');
    }
};
