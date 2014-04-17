#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

//Some stuf from iq. thx.
float hash( float n )
	
{
    return fract(sin(n)*43758.5453);
}

float dist(vec2 p1, vec2 p2)
{
	return sqrt(((p2.x-p1.x)*(p2.x-p1.x))+((p2.y-p1.y)*(p2.y-p1.y)));
}

float checkCircle(vec2 circlePos, vec2 pixelPos, float scale)
{
	float distVar = dist(circlePos, pixelPos)/scale;
	if(distVar < 0.09) { return 1.0; }
	//else if(distVar < 0.093) { return 0.1; }
	return 0.0;
}
vec3 colorize(float i)
{

	return vec3(sin(i*0.7+14.0)+0.3,
		    sin(i*0.7+10.0)+0.5,
		    sin(i))+0.9;
}

float rand(vec2 co, float offset) {
    return fract(sin(dot(co.xy ,vec2(12.9898+offset,78.233+offset))) * (43758.5453+offset));
} 
vec3 randCol(vec2 co, vec3 inCol){
	return vec3(rand(co, inCol.x+10.0),rand(co, inCol.y+20.0),rand(co, inCol.z+30.0));
}
vec3 randBW(vec2 co, vec3 inCol){
	float c = rand(time+co, inCol.x+10.0);
	return vec3(c,c,c);
}
void main( void ) {
	vec3 color = vec3(0,0,0);
	
	for(int i=0; i < 50; i++)
	{
		vec2 pos = vec2(
			sin(((mouse.x*2.2)+100.0)*hash(float(i)*3.5))*0.9, 
			cos(((mouse.y*3.3)+100.0)*hash(float(i)*5.0))*0.9);
		color = color + vec3(checkCircle(pos, ((vec2(gl_FragCoord.x, gl_FragCoord.y)/resolution)*vec2(2))-vec2(1), ((sin(float(i))+1.0)/1.9)+0.7))*colorize(float(i));

		
	}
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	gl_FragColor = .01 + vec4(.339*dot(texture2D(backbuffer,position), vec4(randBW(position,color), 1.0 )));
	
}