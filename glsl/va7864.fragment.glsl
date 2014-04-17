//Just some lame-ness :)
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	position.x= position.x*2.0-0.5;
	float colx = distance(vec2(0.2,0.5),position.xy);
	float colx2 = distance(vec2(0.2,0.5),position.xy+0.1);
	colx = 1.0-colx;
	colx2 = 1.0-colx2;
	
	float comb= max(colx,colx2);
	
	float result = smoothstep(0.8,0.9,comb);
	vec3 finalcol = vec3(result,result,result);
	gl_FragColor = vec4(finalcol.xxx,1.0);

}