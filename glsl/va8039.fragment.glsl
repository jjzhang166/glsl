#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) 
{
	float posX = gl_FragCoord.x;
	float posY = 300.0 - gl_FragCoord.y;
	float curPosX = posX - time;
	float height = 153.0;
	
	float yMin = 150.0;
	
	float clamp1 = 150.0;
	float clamp2 = 190.0;
	float clamp3 = 230.0;
	
	float clamp4 = 450.0;
	float clamp5 = 490.0;
	float clamp6 = 530.0;
	
	if(posX >= clamp1 &&  posX <= clamp2)
	{
		height += mix(0.0,150.0,(posX - clamp1) / (clamp2 - clamp1));
	}
	if(posX >= clamp2 &&  posX <= clamp3)
	{
		yMin -= mix(0.0,150.0,(posX - clamp2) / (clamp3 - clamp2));
	}
	
	if(posX >= clamp4 &&  posX <= clamp5)
	{
		height += mix(0.0,75.0,(posX - clamp4) / (clamp5 - clamp4));
	}
	if(posX >= clamp5 &&  posX <= clamp6)
	{
		yMin -= mix(0.0,75.0,(posX - clamp5) / (clamp6 - clamp5));
	}
	

	
	if(gl_FragCoord.y >= yMin && gl_FragCoord.y <= 300.0)
	{
		
		
		if((posX + cos(time) * -550.0) >= (150.0) && (posX + cos(time) * -550.0) <= 165.0)
		{

			if(abs(sin(posX)) >= 0.1 && gl_FragCoord.y >= yMin && gl_FragCoord.y <= (height))
			{
				gl_FragColor.x = 1.0;
				gl_FragColor.y = 1.0;
				gl_FragColor.z = 1.0;
			}
		}
	}
}