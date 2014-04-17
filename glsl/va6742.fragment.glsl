#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;

void main() {
	vec2 v = -1.0 + gl_FragCoord.xy / vec2(resolution.x / 2.0, resolution.y / 2.0);
	
	// Tunnel.
	float r = pow(pow(abs(0.0), 18.0) + pow(abs(0.0), 10.0), 1.8 / 28.0);
	vec2 t = vec2(0.0 * 64.0 + 1.0 / r, atan(0.0, 0.0));
	
	// Texture.
	t = fract(2.0 * t) - 0.5;
	vec4 col = (1.0 - pow(dot(t.xy, t.xy), 0.3)) * vec4(2.0, 1.8, 1.6, 0.0) + vec4(0.3, 0.2, 0.1, 0.0) + 0.12 * vec4(v, 0.0, 0.0);
	
	// Final output.
	gl_FragColor = vec4(0, 0, 0, 0);
}

/*
void main() {
    vec2 v = -1.0 + gl_FragCoord.xy / vec2(640 / 2, 384 / 2); // too lazy to manually calculate

    // Tunnel.
    float r = pow(pow(abs(v.x), 18.0) + pow(abs(v.y), 10.0), 1.8 / 28.0);
    vec2 t = vec2(gl_Color.x * 64.0 + 1.0 / r, atan(v.x, v.y));
    
    // Texture.
    t = fract(2 * t) - 0.5;
    vec4 col = (1 - pow(dot(t.xy, t.xy), 0.3)) * vec4(2, 1.8, 1.6, 0) + vec4(0.3, 0.2, 0.1, 0) + 0.12 * vec4(v, 0, 0);
    
    // Final output.
    gl_FragColor = col / (2.5 * r);
}
*/