

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

float f(float x, float y,float z) {
	x+=x+sin(x*1.0);
	y+=y+sin(y*3.0);
	
	return 1.0/( sin( x + time*0.1*z ) * 4. - y ) / cos(time + (y*x)) * 15.;
}

void main( void ) {
	
	 float zoom = (sin(time)/0.2)+10.0; ///50.0;
	 float cameraX = 5.0;
	 float cameraY = (zoom*3.0)/15.0;
	 
	vec2 p = ( gl_FragCoord.xy /(resolution.x * 1.0/zoom));
	float x = p.x - cameraX;
	float y = p.y - cameraY;

	float a = f(x+sin(-time*0.1),y+sin(time*0.55),2.0);
	float b = f(x+sin(-time*1.83),y+sin(time*0.94),1.0);

	float time = time / 10000.0;
	
	float borderDarkness = mix(sin(gl_FragCoord.x/resolution.x*3.14) , sin(gl_FragCoord.y/resolution.y*3.14), 0.9);
	float scaline = mix(borderDarkness/2.0, abs(sin(gl_FragCoord.y/0.5 + time * 2.0))/2.0, 0.3);
	float dimming = (sin(time) * cos(time*1000.0) * sin(time))/4.0;
	float noise = rand(vec2(floor(gl_FragCoord.x/1.0), floor(gl_FragCoord.y/1.0)));
	
	float color = mix(borderDarkness*a , scaline, 0.9) + (dimming*b) + noise*0.5;

	gl_FragColor = vec4(color, color, color, 1.0);
}