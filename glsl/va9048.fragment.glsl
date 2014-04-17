//Playing with trig for the first time!
//Any improvements to this will be greatly appreciated; I am trying to learn this myself and therefore I don't know the most efficent and concise practices.
//Thanks!

precision mediump float;
uniform float time;
uniform vec2 resolution;

#define PI 3.141

bool shouldDraw(vec2 pointPosition, vec2 currentPosition) {
	float myDist = distance(pointPosition, currentPosition );
	return myDist < 0.005;
}

void main( void ) {

	vec2 position = ((gl_FragCoord.xy / resolution.xy));
	
	vec3 color;
	
	if (position.x >= 0.06 && position.x <= 0.065) {color.rgb = vec3(0.5);}
	if (position.y >= 0.495 && position.y <= 0.505) {color.rgb = vec3(0.5);}
	
	for (float i = 0.0; i <= 10.0; i++) {
		if ( shouldDraw( vec2( (i / 10.0) * 0.932 + 0.0625 , sin(i / 10.0 * (2.0 * PI)) / 4.0 + 0.5), position ) ) color = vec3(0.5, 1.0, 0.5);
	}
	
	gl_FragColor = vec4(color, 1.0);

}