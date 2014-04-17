#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

struct Circle
{
	vec2 position;
	float innerRadius;
	float outerRadius;
	vec4 color;
};
	
const int circleCount = 6;
Circle circles[circleCount];

void onInit()
{
	circles[0] = Circle(vec2(  0.0,   0.0), 10.0, 100.0, vec4(1.0, 0.0, 0.0, 0.0));
	circles[1] = Circle(vec2(500.0, 250.0), 80.0, 200.0, vec4(0.0, 1.0, 0.0, 0.0));
	circles[2] = Circle(vec2(680.0, 480.0), 10.0, 100.0, vec4(0.0, 0.0, 1.0, 0.0));
	circles[3] = Circle(vec2(880.0, 280.0), 10.0, 100.0, vec4(0.0, 1.0, 1.0, 0.0));
	circles[4] = Circle(vec2(280.0, 680.0), 10.0, 100.0, vec4(1.0, 0.0, 1.0, 0.0));
	circles[5] = Circle(vec2(850.0, 650.0), 80.0, 150.0, vec4(1.0, 1.0, 0.0, 0.0));
}

void main( void ) 
{
	onInit();
	
	circles[1].position.x += 1.0;
	
	
	vec4 color = vec4(0);
	
	vec2 pixelPosition = gl_FragCoord.xy;
	circles[0].position = mouse * resolution;
	
	for(int i = 0; i < circleCount; i++)
	{
		if(length(pixelPosition - circles[i].position) <= circles[i].outerRadius)
		{
			if(length(pixelPosition - circles[i].position) <= circles[i].innerRadius)
				color += circles[i].color;
			else
			{
				color += circles[i].color * (circles[i].outerRadius - length(pixelPosition - circles[i].position)) / (circles[i].outerRadius - circles[i].innerRadius);
			}
		}
	}
	
	gl_FragColor = color;

}