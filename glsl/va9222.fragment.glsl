
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

/*
 * inspired by http://www.fractalforums.com/new-theories-and-research/very-simple-formula-for-fractal-patterns/
 *  inversions et rotations
 * public domain
 */
 
 vec2 rotation(vec2 u,float a,vec2 centre){
 	vec2 v=u-centre;
 	return vec2(cos(a)*v.x-sin(a)*v.y,sin(a)*v.x+cos(a)*v.y)+centre; }
 	
 vec2 inversion(vec2 u,vec2 centre,float k){ 
 	vec2 v=u-centre;
 return v/dot(v,v)*k + centre;}	

void main( void ) {
	vec2 pos =2.0*(gl_FragCoord.xy/ resolution.xy) -1.0;
	float sum = 0.0;	
	for ( int i = 0; i <10; i++ ){		
		pos= inversion(pos,vec2(0.2*cos(time*0.5),0.3*sin(time*0.5)),2.0);			
		pos =rotation(pos ,time*0.1,vec2(2.0*cos(time*0.5),3.0*sin(time*0.1)));
		pos= inversion(pos,vec2(-0.3*sin(time*0.5),0.2*cos(time*0.5)),2.0);	
		sum +=  dot(pos,pos);	
	}	
	float col =sqrt(abs(sum));
	gl_FragColor = vec4(1.0+ cos(col*3.0), 1.0-sin(col*2.0),abs(sin(col)), 1.0 ) ;}
