

#ifdef GL_ES
precision mediump float; 
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//Old TV by curiouschettai

float rand(vec2 co){
	float t = time+1000.0;
    return fract(sin(dot(co.xy ,vec2(1.9898,7.233))) * t*t);
}

void main( void ) {

	float borderDarkness = mix(sin(gl_FragCoord.x/resolution.x*3.14) , sin(gl_FragCoord.y/resolution.y*3.14), 0.5);
	float scaline = mix(borderDarkness/2.0, abs(sin(gl_FragCoord.y/2.0))/2.0, 0.5);
	float dimming = (sin(time) * cos(time*10.0) * sin(time))/45.0;
	float noise = rand(vec2(floor(gl_FragCoord.x/3.0), floor(gl_FragCoord.y/3.0)));
	
	float color = mix(borderDarkness , scaline, 0.5) + dimming + noise/5.0;
	
	gl_FragColor = vec4(color, color, color, 1.0);
}