#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

struct ViewportParameters {
	vec2 scale;
	vec2 position;
};

struct BitmapParameters {
	sampler2D texture;
	vec2 textureSize, texelSize;
};

struct BitmapVertexInput {
	vec2 position;
	vec2 textureTopLeft, textureBottomRight;
	vec2 scale;
	vec2 origin;
	float rotation;
	int cornerIndex;
	vec4 multiplyColor;
	vec4 addColor;
};
	
struct BitmapFragmentInput {
	vec2 position;
	vec2 uv;
	vec2 textureTopLeft, textureBottomRight;
	vec4 multiplyColor;
	vec4 addColor;	
};
	
uniform ViewportParameters Viewport;
uniform BitmapParameters Bitmap;
uniform mat4 ProjectionMatrix;
uniform vec2 Corners[4];

void ScreenSpaceVertexShader (
	in BitmapVertexInput vertexInput,
	out BitmapFragmentInput fragmentOutput
) {
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float color = 0.0;
	color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;

	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );
}