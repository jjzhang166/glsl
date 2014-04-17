#ifdef GL_ES
precision highp float;
#endif

#define MAX_DISTANCE 10000.0
#define MAX_ITERATIONS 1024
#define ITER_STEP 0.01 
#define COLOR_FREQ 1.2
#define BP_EXPONENT 70.0 // Blinn-phong shading exponent

// forked just to thank whoever made this for documenting their code; really helpful! :)

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
float EPSILON = sin(time) + 1.0;
// Simple sphere struct
struct Sphere {
    vec3 origin;
    float radius;
};

// Distance from a sphere object to the ray coordinates, the key to sphere marching
float distance(Sphere s, vec3 coord) {
    coord.x = mod(coord.x+.3, .6) - .3;
    coord.y = mod(coord.y+.3, .6) - .3;

    return distance(s.origin, coord) - s.radius;
}

// Approximate a surface normal by sampling nearby points
vec3 surface_normal(Sphere s, vec3 coord) {
    vec2 delta = vec2(EPSILON, 0.0);
    return normalize(vec3(
        distance(s, coord + delta.xyy) - distance(s, coord - delta.xyy), // change along X
        distance(s, coord + delta.yxy) - distance(s, coord - delta.yxy), // change along y
        distance(s, coord + delta.yyx) - distance(s, coord - delta.yyx) // change alonsg z
    ));
}

// A simple little color wheel
vec3 color(float marker) {
    return vec3(1,1,1);
}

void main( void ) {
    vec3 ray_origin = vec3(0, 0, -1); // origin is the center of the screen
    vec3 ray = ray_origin; // current ray position
    vec3 ray_direction = normalize(vec3(2.0 * gl_FragCoord.xy / resolution.xy - 1.0, 1)); // Adding some perspective
    vec3 light = vec3(mouse.xy * 2.0 - 1.0, 0); // Simple light position

    Sphere s = Sphere(vec3(0, 0, 1.0), .2); // One sphere at the center of the screen, 200 units in and 50 units in radius
    
    // Sphere marching
    float dist = MAX_DISTANCE;
    for (int i = 0; i < MAX_ITERATIONS; ++i) {
        dist = distance(s, ray); // Get distance to the sphere
        ray += dist * ray_direction; // dist gives us the maximum length we can move in any direction with certainty, and not hit anything.
                                     // Move the ray forward along its direction for that distance
        if (dist < EPSILON || dist > MAX_DISTANCE) break; // Break out of marching if we're close enough to the object, 
                                                          // or if the minimum distance is far enough that we consider the ray "out of bounds"
    }
    
    gl_FragColor = vec4(0.0); // Black world / empty space
    
    // If we hit an object, the pixel isn't empty space so fill it in
    if (dist < EPSILON) {
        // Blinn-phong lighting
        vec3 light_direction = normalize(light - ray);
        vec3 surface_norm = surface_normal(s, ray); // Calculate surface normal at that point
        vec3 h_vec = normalize(light_direction + -ray_direction); // Compute the half-vector, noting the ray_direction in reverse leads back to the eye
        float HdotN = max(dot(h_vec, surface_norm), 0.0); // Find the angle between the surface normal and the half-vector
        vec3 specular = vec3(1.0, 1.0, 1.0) * pow(HdotN, BP_EXPONENT); // Calculate specular (color=white * intensity at current position)
        vec3 diffuse = color(time/2.0) * max(0.0, dot(surface_norm, light_direction)); // diffuse color (object color (time-variant) * angle between surface norm and light direction
        gl_FragColor = vec4(specular + diffuse, 1.0); // Final pixel color represents object with blinn-phong shading - directional lighting + specular
    }
}
