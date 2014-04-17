#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	vec4 col;
	//col = vec4(sqrt(p.x*p.x+p.y*p.y),sqrt((1.0-p.y)*(1.0-p.y)+(1.0-p.x)*(1.0-p.x)),sqrt((1.0-p.y)*(1.0-p.y)+p.x*p.x), 0.0);
	//float tf = sin(time*3.1415926535*2.0/3.0)+2.0;
	float tf = time;
	float nf = (sin((-tf/11.0+sqrt((.5-p.x)*(.5-p.x) +(.5-p.y)*(.5- p.y)))*120.0)+1.0)/2.0;
	//col *= vec4(nf,nf,nf,0);
	//col/=1.0;
	//nf /= 1.0;
	float r = nf*mouse.x;
	float b = nf*mouse.y;
	col = vec4(r,(r+b)/2.0,b,1);
	gl_FragColor = col;
}