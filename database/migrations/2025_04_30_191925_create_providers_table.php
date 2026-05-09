<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('providers', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade'); // provider is a user
            $table->string('profession');
            $table->text('bio')->nullable();
            $table->string('location');
            $table->timestamps();
            $table->enum('status', ['pending', 'accepted', 'refused', 'suspended'])->default('pending')->nullable();
            $table->text('suspend_reason')->nullable();
        });
        
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('providers');
    }
};
