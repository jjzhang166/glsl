#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;

void main( void )
{
	vec4 gridColor           = vec4( 0.1215686274509804,
					 0.1372549019607843,
					 0.1411764705882353,
					 1.0 );
	vec4 grid32x32Color      = vec4( 1.0, 1.0, 1.0, 0.42 * 0.42 * 0.07 * 1.0 );
	vec4 grid64x64Color      = vec4( 1.0, 1.0, 1.0, 0.42 * 0.42 * 0.07 * 1.0 );
	vec4 gridMarks32x32Color = vec4( 1.0, 1.0, 1.0, 0.42 * 0.66 * 0.07 * 1.0 );
	vec4 gridMarks64x64Color = vec4( 1.0, 1.0, 1.0, 0.42 * 0.27 * 0.66 * 1.0 );

	gridColor.rgba += clamp( ceil( mod( resolution.x - gl_FragCoord.x, 32.0 ) )       - 31.0, 0.0, 1.0 ) * grid32x32Color.rgba * grid32x32Color.a;
	gridColor.rgba += clamp( ceil( mod( resolution.y - gl_FragCoord.y - 1.0, 32.0 ) ) - 31.0, 0.0, 1.0 ) * grid32x32Color.rgba * grid32x32Color.a;

	gridColor.rgba += clamp( ceil( mod( resolution.x - gl_FragCoord.x, 64.0 ) )       - 63.0, 0.0, 1.0 ) * grid64x64Color.rgba * grid64x64Color.a;
	gridColor.rgba += clamp( ceil( mod( resolution.y - gl_FragCoord.y - 1.0, 64.0 ) ) - 63.0, 0.0, 1.0 ) * grid64x64Color.rgba * grid64x64Color.a;

	gridColor.rgba += clamp( ceil( mod( resolution.x - gl_FragCoord.x - 2.0, 32.0 ) ) - 27.0, 0.0, 1.0 ) *
			  clamp( ceil( mod( resolution.y - gl_FragCoord.y - 1.0, 32.0 ) ) - 31.0, 0.0, 1.0 ) * gridMarks32x32Color.rgba * gridMarks32x32Color.a;
	gridColor.rgba += clamp( ceil( mod( resolution.y - gl_FragCoord.y - 3.0, 32.0 ) ) - 27.0, 0.0, 1.0 ) *
			  clamp( ceil( mod( resolution.x - gl_FragCoord.x + 0.0, 32.0 ) ) - 31.0, 0.0, 1.0 ) * gridMarks32x32Color.rgba * gridMarks32x32Color.a;

	gridColor.rgba += clamp( ceil( mod( resolution.x - gl_FragCoord.x - 2.0, 64.0 ) ) - 59.0, 0.0, 1.0 ) *
			  clamp( ceil( mod( resolution.y - gl_FragCoord.y - 1.0, 64.0 ) ) - 63.0, 0.0, 1.0 ) * gridMarks64x64Color.rgba * gridMarks64x64Color.a;
	gridColor.rgba += clamp( ceil( mod( resolution.y - gl_FragCoord.y - 3.0, 64.0 ) ) - 59.0, 0.0, 1.0 ) *
			  clamp( ceil( mod( resolution.x - gl_FragCoord.x + 0.0, 64.0 ) ) - 63.0, 0.0, 1.0 ) * gridMarks64x64Color.rgba * gridMarks64x64Color.a;
	gl_FragColor = gridColor;
}
