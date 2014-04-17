#ifdef GL_ES
precision mediump float;
#endif
#define PROCESSING_COLOR_SHADER




uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;



float etoile(vec2 p){
	vec2 ap = abs(p);
	float retour=ap.x + ap.y;
	if(ap.x <=2.0*ap.y && ap.y<=ap.x) retour=1.5*ap.x; 
	if(2.0*ap.x > ap.y  && ap.y>=ap.x) retour=1.5*ap.y; 
	return retour;
}

void main( void ) {
	float a=time/1000.0;
	vec2 souris=vec2(-1.0+cos(a),-1.0+sin(a));
	vec2 position = ( gl_FragCoord.xy / resolution.xy * 2.0) +0.5*souris.xy;
	position *=6.0;
	mat2  rtz=mat2(cos(a),-sin(a),sin(a),cos(a));
	vec2 pos=rtz*position;
	float d = etoile(pos);
	d=mod(d,2.0);
	gl_FragColor = vec4(d,0,0,1);
	
}