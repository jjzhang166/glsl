
#ifdef GL_ES
precision lowp float;
#endif

uniform float time;
uniform vec4 mouse;
uniform vec2 resolution;

const int nrOfPoints = 50;
float points[nrOfPoints];
//float distances[nrOfPoints];
void main( void ) {
	
	//float frame = 1463.0;
	float frame = (time);

	for(int i = 0; i < nrOfPoints; i++){
		//calculate
		points[i] =
			distance(
			resolution.xy/2.0 + sin(0.2*frame *vec2(i+1,2*i+1))*resolution.xy/2.0, 
			gl_FragCoord.xy );

		//insert THIS DOESNT WORK
		//for(int j = i - 1; j >= 0; j--){
		//	if (points[j] <= points[i]) break;
		//	points[j + 1] = a[j];
		//}
	}
	
	float c = float( points[25]/points[24] > points[20]/points[19] );
	

	gl_FragColor = vec4(c, c, c, 1.0);
}
