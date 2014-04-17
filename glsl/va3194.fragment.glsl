// by rotwang
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;


void main( void ) {
   
	vec2 unipos = gl_FragCoord.xy / resolution;
	vec2 pos = unipos *2.0-1.0;
	vec2 apos = abs(pos);
	
	float xdiv = 4.0;
	float ydiv = 2.0;
	float a = mod(unipos.x,1.0/xdiv)*xdiv;
	float b = mod(unipos.y,1.0/ydiv)*ydiv;
	vec3 clr = vec3(pow(a,b));
    gl_FragColor = vec4(clr, 1.0);
}