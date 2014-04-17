#ifdef GL_ES
precision highp float;
#endif

//uniform float time;
uniform vec2 resolution;

void main( void ) {
	vec2 position = gl_FragCoord.xy / resolution;
	position = vec2(position.x * 3.5 - 2.5, position.y * 2.0 - 1.0);
	vec2 calc = vec2(0.0, 0.0);

  	float outiteration = 0.0;
  	//float max_iteration = 100.0;
	float temp;
  	
	for (float iteration = 0.0; iteration < 100.0; iteration += 1.0 )
  	{
		if (calc.x * calc.x + calc.y * calc.y > 4.0)
			break;
   		temp = calc.x*calc.x - calc.y*calc.y + position.x;
   		calc.y = 2.0*calc.x*calc.y + position.y;

   		calc.x = temp;
		outiteration = iteration;
  	}

 	gl_FragColor = vec4(outiteration/100.0, outiteration/100.0, outiteration/100.0, 1);
}