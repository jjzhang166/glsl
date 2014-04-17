#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec2 moffset=2.0*(mouse.xy-vec2(0.5));
float zoom=1.0;
float slowtime=1.0;
float cycle=sin(slowtime*time)*1.5;
float invcycle=1.0-cycle;
void main( void ) {
	vec2 position = (((gl_FragCoord.xy-(resolution.xy/2.0))/resolution.x*5.0+vec2(-0.6,0))-moffset)*(1.0/zoom)+moffset;
	float r=position.x,i=position.y,tr=0.0;
	float iterations=0.0;
	for(int iter=0;iter<25;iter++){
		tr=r*r-i*i+cycle*position.x+invcycle*moffset.x;
		i=2.0*i*r+cycle*position.y+invcycle*moffset.y;
		r=tr;
		iterations++;
		if(r*r+i*i>4.0){
			iterations=(log(r*r+i*i)/log(2.0));
			break;
		}
		if(r*r+i*i<1.0){
		moffset.x=-1.0;
		
		}
	
	
	
	}
	gl_FragColor = vec4(iterations/55.0);
}