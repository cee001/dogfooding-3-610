package com.todosys.todo.todos;

public enum SiTodoPriority {
    URGENT(1, "紧急", "#ff4444"),
    IMPORTANT(2, "重要但不紧急", "#ff9800"),
    NORMAL(3, "常规", "#2196f3"),
    LOW(4, "低优先级", "#8bc34a");

    private final int level;
    private final String label;
    private final String color;

    SiTodoPriority(int level, String label, String color) {
        this.level = level;
        this.label = label;
        this.color = color;
    }

    public int getLevel() {
        return level;
    }

    public String getLabel() {
        return label;
    }

    public String getColor() {
        return color;
    }

    public static SiTodoPriority fromLevel(int level) {
        for (SiTodoPriority priority : values()) {
            if (priority.getLevel() == level) {
                return priority;
            }
        }
        return NORMAL;
    }
}
