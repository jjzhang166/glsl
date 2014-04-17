// Textil, by rotwang

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;


void main(void)
{
	
	vec2 pos = gl_FragCoord.xy;
	
	float x = pos.x * mod(pos.x, 1600.0);
	float sx = sin(x*0.05)*0.5+0.5;
	float sxa = 1.0-pow(sx, 64.0);
	float sxb = 1.0-pow(sx, 16.0);
	sx = mix(sxa+sxa, sxb, sx);
	
	float y = pos.y * mod(pos.y, 800.0);
	float sy = sin(y*0.1)*0.5+0.5;

	sy = 1.0-pow(sy, 64.0);
	
	float shade = sx*sy; 
	vec3 color = vec3(shade, shade*0.4, shade*0.3);
	
	gl_FragColor = vec4(color, 1.0);
}