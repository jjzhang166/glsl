// by rotwang (2012)
// @mod+ flicker

#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	float aspect = resolution.x / resolution.y;
	vec2 unipos = gl_FragCoord.xy / resolution;
	vec2 pos = unipos*2.0-1.0;
	pos.x *= aspect;
	vec2 obpos = vec2(0.0);
	//obpos.x *= aspect;

	float t = time * 0.25;
	float clamp_a = clamp( fract(t), 0.0,0.5 );
	float clamp_sint = sin(clamp_a);
	
	
	float len = length(obpos-pos)*0.5;
	float sm = 0.05;
	float r = atan(clamp_sint,len*2.0); 
	float g = atan(clamp_sint,len*4.0); 
	float b = smoothstep(len-sm, len+sm, clamp_sint);
	
	vec3 clr = vec3(r,g,b);
	
	clr *= step(fract(time*5.0),0.5);
	clr *= step(fract(t),0.6);
	
	gl_FragColor = vec4(clr, 1.0);

}