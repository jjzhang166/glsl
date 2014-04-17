#ifdef GL_ES
precision highp float;
#endif
// by instituto tecnológico de mazatlán
uniform float time;
uniform vec2 resolution;


float distancia(vec2 p1, vec2 p2){
	float x = p1.x-p2.x;
	float y = p1.y-p2.y;
	return sqrt((x*x)+(y*y));
}
void main()
{

	float dist = distancia(gl_FragCoord.xy, resolution/2.0);
	gl_FragColor = 
		(500.0/(dist*dist* (sin(time)) ))
		*vec4(0.0,1.0,1.0, 1.0)+
		(2000.0/(dist*dist* abs(1.0/sin(time))))
		*vec4(1.0,1.0,1.0, 1.0);


}