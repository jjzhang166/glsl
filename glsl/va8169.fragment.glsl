#ifdef GL_ES
precision mediump float;
#endif

// ahh, there's a texture for feedbacks :D
uniform sampler2D backbuffer;


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;



// rotate counter clockwise in degree
vec2 rotate(in vec2 v, float deg)
{
	float 	ca = deg * 3.14159265 / 180.0, 
		sa = sin(ca);
		ca = cos(ca);

	return vec2(	v.x * ca - v.y * sa,
			v.x * sa + v.y * ca);
}


// return color of backbuffer texture for coordinates [-1,1]
vec3 tex(in vec2 tc) { return texture2D(backbuffer, tc * 0.5 + 0.5).xyz; }

void main( void ) {
	
	// screen coords [-1,1]
	vec2 scr = gl_FragCoord.xy / resolution.xy * 2.0 - 1.0;
	
	// create some gradient
	vec3 col = vec3(smoothstep(0.9, 1.0, mod(scr.y * 10.0,1.0)));
	// make it colorful
	col = abs(vec3(sin(col.x*10.0), sin(col.x*13.3), sin(col.x*6.9)));
		
	// add transformed feedback
	col += 0.8 * tex(rotate(scr * 0.7, sin(time*0.2)*45.0)) * vec3(0.8,1.0,0.97) ;
	
	// output the crap
	gl_FragColor = vec4( col, 1.0 );
}