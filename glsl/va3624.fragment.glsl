

#ifdef GL_ES
precision mediump float; 
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//Old TV by curiouschettai

float rand(vec2 co){
	float t = time+100.0;
    return fract(sin(dot(co.xy ,vec2(1.9898,7.233))) * t*t);
}

void main( void ) {
	
	float time = time / 10000.0;
	
	float borderDarkness = mix(sin(gl_FragCoord.x/resolution.x*3.14) , sin(gl_FragCoord.y/resolution.y*3.14), 0.9);
	float scaline = mix(borderDarkness/2.0, abs(sin(gl_FragCoord.y/0.5 + time * 2.0))/2.0, 0.3);
	float dimming = (sin(time) * cos(time*1000.0) * sin(time))/4.0;
	float noise = rand(vec2(floor(gl_FragCoord.x/1.0), floor(gl_FragCoord.y/1.0)));
	
	float color = mix(borderDarkness , scaline, 0.9) + dimming + noise*0.5;
	
	gl_FragColor = vec4(color * noise, color*noise, color*noise, 1.0);
}