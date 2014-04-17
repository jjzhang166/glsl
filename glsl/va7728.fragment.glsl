#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;
const float MaxIteration = 50.0;
const float TheMultipleyer = 2.0;
const float Bailout = 2.5;



const float DistanceCalculateCorrection = TheMultipleyer/2.0;
void main( void ) {

	vec2 Pixelpos = resolution.xy;
	vec2 ScalePos = surfacePosition.xy;
	vec3 finalColor = vec3(0,0,0);
	
	float LoopX = ScalePos.x;
	float LoopY = ScalePos.y;
	
	float Iteration = 0.0;
	
	for(float i = 0.0;i<MaxIteration; i++){
		if (distance(vec2(DistanceCalculateCorrection),vec2(LoopX,LoopY)) > Bailout){
			break;
		}
		LoopX = LoopX*LoopX-LoopX*TheMultipleyer;
		LoopY = LoopY*LoopY-LoopY*TheMultipleyer;
		
		Iteration += 1.0;
	} 
	
	finalColor = vec3(cos(Iteration/5.0),sin(Iteration/2.0),tan(Iteration/10.0));
	
	gl_FragColor = vec4(finalColor, 1.0 );

}