# Trend Indicator Definitions

This protocol defines the canonical trend indicator format used across all sigint methodology skills.

## The Three Values

All methodology skills MUST use these exact definitions when classifying trend direction:

### INC (Increasing)
- Variable is trending upward / measurable upward movement
- Multiple confirming signals support the direction
- Example: "AI adoption growing 40% YoY"

### DEC (Decreasing)
- Variable is trending downward / measurable downward movement
- Multiple confirming signals support the direction
- Example: "On-premise deployments declining 15% annually"

### CONST (Constant)
- No significant directional movement
- OR insufficient data to determine direction
- Example: "Market share stable at ~30%"

## Notation Formats

### Simple Format
Used in tables, summaries, and inline references:
- `INC`, `DEC`, `CONST`
- Example: `Revenue Growth: INC`

### Formal Notation (for trend-modeling)
Used when expressing variable relationships:
- `INC(X, Y)` — X and Y trend in the same direction (positive correlation)
- `DEC(X, Y)` — X and Y trend in opposite directions (negative correlation)
- Example: `INC(Market Size, Competition)` — as market grows, competition increases

### Extended Notation (optional)
For nuanced analysis with acceleration/deceleration modifiers:

| Code | Meaning | Description |
|------|---------|-------------|
| AG | Accelerating Growth | INC with increasing rate |
| DG | Decelerating Growth | INC with decreasing rate |
| AD | Accelerating Decrease | DEC with increasing rate |
| DD | Decelerating Decrease | DEC with decreasing rate |

When using extended notation, ALWAYS include this definition table in the output.

## Correlation-to-Trend Conversion

- Positive correlation (r > 0.3) → INC relationship
- Negative correlation (r < -0.3) → DEC relationship
- Weak correlation (-0.3 < r < 0.3) → CONST relationship

## Usage Rules

1. Every trend indicator MUST use exactly one of: `INC`, `DEC`, `CONST`
2. Tables with trend columns MUST include the trend indicator in every row
3. Trend analysis bullets MUST use the format: `Area: INC/DEC/CONST - [Evidence sentence]`
4. When citing a trend, at least one supporting data point must follow
5. NEVER use placeholder values — every trend indicator must be backed by evidence
