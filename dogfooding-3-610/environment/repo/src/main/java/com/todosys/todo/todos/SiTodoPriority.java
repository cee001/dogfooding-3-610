package com.todosys.todo.todos;

import com.alibaba.fastjson.annotation.JSONType;

@JSONType(serializeEnumAsJavaBean = true)
public enum SiTodoPriority {
    URGENT(1, "紧急", "#ff4757"),
    IMPORTANT(2, "重要", "#ff9f43"),
    NORMAL(3, "常规", "#3498db"),
    LOW(4, "低优先级", "#2ed573");

    private final int order;
    private final String label;
    private final String color;

    SiTodoPriority(int order, String label, String color) {
        this.order = order;
        this.label = label;
        this.color = color;
    }

    public int getOrder() {
        return order;
    }

    public String getLabel() {
        return label;
    }

    public String getColor() {
        return color;
    }

    public static SiTodoPriority fromOrder(int order) {
        for (SiTodoPriority priority : values()) {
            if (priority.order == order) {
                return priority;
            }
        }
        return NORMAL;
    }
}
