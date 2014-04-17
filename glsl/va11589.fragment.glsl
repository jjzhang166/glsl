#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;

void main( void ) {
	
	vec2 pos = ( gl_FragCoord.xy / resolution.xy ) - 0.5; // position of our pixel, with vec2(0.0, 0.0) centred
	pos.x *= resolution.x / resolution.y; // correct for aspect ratio, e.g. 1024/768
	float len = length(pos * 1.5); // how far is our pixel from centre
        vec3 col = vec3(0.0); // col is the colour we'll return
	if (len < 0.3) { col.rgb = vec3(0.4,1.0,0.0); } // if we are not far from centre, set our colour to a green
	
	if (pos.x < 0.0) { col.rgb *= 0.75; } // darken left hand side

	if (pos.y > 0.0) { col.r *= 2.5; }
	
	
	gl_FragColor = vec4(col, 1.0); // return the colour

}