/* wzl was here again              
 * making your eyes cum since 2008 
 *
 * http://wzl.vg  
 * http://trbl.at 
 */                               

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

int grid[10000];
const int maxit = 200;

void main( void ) {

	vec2 q = gl_FragCoord.xy / resolution.xy;
	vec2 p = ( gl_FragCoord.xy / resolution.xy )*4.0;
	p.x-=2.0;
	p.y -= 2.0;
	p *= (0.5 - mod(time * 0.05, 1.0)) / 4.0 ;
	p.x += sin(time * 0.0)*0.3 - .2;
	p.y += cos(time * 0.0)*0.3 + 0.2;

	
	float tt = time * .0 + abs(sin(time * 0.1) * 2.0);

	vec2 c = vec2(-0.745 + (1.0 + cos(tt) / 2.0) * 0.5, 0.19+ (1.0 + sin(tt) / 2.0) * 0.5);
	float t = 0.0;
	
	vec3 col = vec3(0.0);
	for( int iterations=0; iterations<maxit; iterations++ )
	{
		p=vec2(p.x*p.x - p.y*p.y, p.x*p.y*2.0) + c;
		if( dot(p,p) >= 4.0 ) 
		{
			if(iterations < maxit)
			col.r = float(iterations) / float(maxit);
			
			if ( iterations < maxit / 3 * 2)
			col.g = float(iterations) / float(maxit) * 0.4 * q.x * 2.0;
			
			if( iterations < maxit / 3)
			col.b = float(iterations + iterations / 3) / float(maxit) * 0.4;
			break;
		}
		t += 1.0 / float(maxit);
	}
	
	gl_FragColor = vec4(mix(col, vec3(t), (sin(time) + 1.0) / 4.0 + 0.5) , 1.0);


}