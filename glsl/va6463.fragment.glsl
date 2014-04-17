#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

bool isOnH( vec2 pos, vec2 startPt ) {
	vec4 color = vec4( 0.0 );
	//vec2 pos = gl_FragCoord.xy;
	bool isOnH = true;;
	float charHeight = 50.0;
	float charWidth = charHeight / 2.0;
	float lineWidth = 4.0;
	if( ( pos.x <= startPt.x + lineWidth && pos.x >= startPt.x - lineWidth ) && ( pos.y >= startPt.y - charHeight  && pos.y <= startPt.y ) )
	{
		
		color.rgb = vec3( 0.0, 1.0, 0.0 );
	}
	else if( pos.x >= startPt.x && pos.x <= startPt.x + charWidth &&
	         pos.y >= startPt.y - ( charHeight / 2.0 ) - lineWidth && pos.y <= startPt.y + lineWidth - charHeight / 2.0 )
	{
		color.rgb = vec3( 1.0, 0.0, 0.0 );
	}
	else if( pos.x >= startPt.x + charWidth - lineWidth && pos.x <= startPt.x + charWidth + lineWidth
	      && pos.y >= startPt.y - charHeight && pos.y <= startPt.y - charHeight / 2.0  )
	{
		color.rgb = vec3( 0.0, 0.0, 1.0 );
	}
	else
	{
		isOnH = false;
	}
	gl_FragColor = color;
	return isOnH;
}

void main( void )
{
	vec3 color = vec3( 0.0 );
	vec2 pt = vec2( 100.0 * sin( time ) + 500.0 , 100.0 * cos( time ) + 150.0 );
	vec2 pt2 = vec2( 100.0 * cos( time ) + 300.0, 100.0 * sin( time ) + 150.0 );
	if( isOnH( gl_FragCoord.xy, pt ) )
	{
		color.r = 1.0;
	}
	else if( isOnH( gl_FragCoord.xy, pt2 ) )
	{
		color.b = 1.0;
	}
	else
	{
	float colorCoefficient = 0.0;
	colorCoefficient += sin( gl_FragCoord.x * cos( time / 15.0 ) * 80.0 ) + cos( gl_FragCoord.y * cos( time / 15.0 ) * 10.0 );
	colorCoefficient += sin( gl_FragCoord.y * sin( time / 10.0 ) * 40.0 ) + cos( gl_FragCoord.x * sin( time / 25.0 ) * 40.0 );
	colorCoefficient += sin( gl_FragCoord.x * sin( time / 5.0 ) * 10.0 ) + sin( gl_FragCoord.y * sin( time / 35.0 ) * 80.0 );
	colorCoefficient *= sin( time / 10.0 ) * 0.5;

	color = vec3( .1* colorCoefficient, colorCoefficient , .1 * sin( colorCoefficient + time / 3.0 ) * 0.75 ), 1.0;
	}
	gl_FragColor = vec4( color, 1.0 );
}




